import pandas as pd
import os
from langchain_community.vectorstores import FAISS
from dotenv import load_dotenv
from langchain_openai import OpenAIEmbeddings
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationalRetrievalChain
from langchain.prompts import (
    ChatPromptTemplate,
    HumanMessagePromptTemplate,
    SystemMessagePromptTemplate,
)
import streamlit as st
from chatbot_preprompts import system_message_prompt_info 

import sys
import re
from pymongo import MongoClient
from transformers import AutoTokenizer, AutoModel
import torch

from langchain_openai import ChatOpenAI
from langchain_community.document_loaders import DataFrameLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA
from langchain.prompts.prompt import PromptTemplate

#from notifTeams import enviar_notificacion_a_teams

def load_dataset(dataset_name="oxford_food_hygiene_cleaned.csv"):
    # Cargar un conjunto de datos desde un archivo CSV
    current_dir = os.path.dirname(os.path.realpath(__file__))  
    file_path = os.path.join(current_dir, dataset_name)  

    df = pd.read_csv(file_path) 
    
    return df

def create_chunks(dataset: pd.DataFrame, chunk_size: int, chunk_overlap: int):
   """
   Crea fragmentos de información a partir del conjunto de datos de negocios en Oxford.
   """
   chunks = DataFrameLoader(
      dataset,
      page_content_column="BusinessName",  
  ).load_and_split(
      text_splitter=RecursiveCharacterTextSplitter(
          chunk_size=1000
      )
  )

   for chunk in chunks:
     business_name = chunk.page_content 
     business_type = chunk.metadata['BusinessType']
     address = chunk.metadata['FullAddress']
     postcode = chunk.metadata['PostCode']
     hygiene = chunk.metadata['Hygiene']
     structural = chunk.metadata['Structural']
     management_confidence = chunk.metadata['ConfidenceInManagement']

     content = (f"Business Name: {business_name} \n"
                f"Type: {business_type} \n"
                f"Address: {address} \n"
                f"PostCode: {postcode} \n"
                f"Hygiene Rating: {hygiene} \n"
                f"Structural Rating: {structural} \n"
                f"Confidence in Management: {management_confidence}")
     
     chunk.page_content = content  # Actualizar contenido del chunk

   return chunks




def get_embeddings(texts, model_name="bert-base-nli-mean-tokens"):
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModel.from_pretrained(model_name)
    
    inputs = tokenizer(texts, padding=True, truncation=True, return_tensors="pt")
    
    with torch.no_grad():
        outputs = model(**inputs)
    
    embeddings = outputs.last_hidden_state.mean(dim=1)
    
    return embeddings

from langchain_openai import OpenAIEmbeddings  

def create_or_get_vector_store(chunks) -> FAISS:
    """Crea o carga la base de datos vectorial de manera local"""
    
    # Usa OpenAIEmbeddings en lugar de una función
    embeddings = OpenAIEmbeddings()

    if not os.path.exists("./vectorialDB"):
        print("CREANDO BASE DE DATOS")
        
        vectorstore = FAISS.from_documents(
            chunks, embeddings  
        )
        vectorstore.save_local("./vectorialDB")

    else:
        print("CARGANDO BASE DE DATOS")
        vectorstore = FAISS.load_local("./vectorialDB", embeddings, allow_dangerous_deserialization=True)

    return vectorstore




def insert_bbdd(parseo):
    client = MongoClient("mongodb://localhost:27017/")  
    database = client["menu"]
    tickets_collection = database["tickets"]
    tickets_collection.insert_one(parseo)
    client.close()

def calculate_retriever(vector_store, dataset):
    k_value = len(dataset)
    print(k_value)
  
    retriever1 = vector_store.as_retriever()
    retriever1.search_kwargs = {'k': 50}  # Retrieve only the top 5 most relevant documents
    return retriever1

def get_conversation_chain(retriever, query, memory):
    """
    Creates a conversational retrieval chain to answer questions based on the dataset.
    """
    # Ensure correct input variables
    prompt = PromptTemplate(
        input_variables=["history", "question"],  
        template=system_message_prompt_info,  
    )

    # Initialize conversational retrieval chain
    retrieval_chain = RetrievalQA.from_chain_type(
        llm=ChatOpenAI(model="gpt-4-1106-preview", temperature=0.0),
        chain_type='stuff',
        retriever=retriever,
        chain_type_kwargs={
            "prompt": prompt,
            "memory": memory
        }
    )

    # Correct way to call the chain in LangChain 1.0+
    response = retrieval_chain.invoke(query)  # ✅ FIXED

    return response['result']
 
