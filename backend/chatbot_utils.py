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


def load_dataset(dataset_name):
    """
    Loads a dataset from a CSV file.
    """
    current_dir = os.path.dirname(os.path.realpath(__file__))  
    file_path = os.path.join(current_dir, dataset_name)  

    df = pd.read_csv(file_path) 
    return df

def create_chunks(dataset: pd.DataFrame, chunk_size: int, chunk_overlap: int):
    """
    Splits the dataset into smaller chunks for efficient processing.
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
        
        chunk.page_content = content  # Update chunk content

    return chunks


def get_embeddings(texts, model_name="bert-base-nli-mean-tokens"):
    """
    Generates text embeddings using a pre-trained transformer model.
    """
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModel.from_pretrained(model_name)
    
    inputs = tokenizer(texts, padding=True, truncation=True, return_tensors="pt")
    
    with torch.no_grad():
        outputs = model(**inputs)
    
    embeddings = outputs.last_hidden_state.mean(dim=1)
    
    return embeddings


def create_or_get_vector_store(chunks, dataset_name) -> FAISS:
    """
    Creates or loads a vector database for each dataset.
    """
    embeddings = OpenAIEmbeddings()

    vector_db_path = f"./vectorialDB/{dataset_name}"  # Dedicated vector database for each CSV file

    if not os.path.exists(vector_db_path):
        #print(f"CREATING VECTOR DATABASE FOR: {dataset_name}")

        vectorstore = FAISS.from_documents(chunks, embeddings)
        vectorstore.save_local(vector_db_path)

    else:
        #print(f"LOADING VECTOR DATABASE FOR: {dataset_name}")
        vectorstore = FAISS.load_local(vector_db_path, embeddings, allow_dangerous_deserialization=True)

    return vectorstore


def get_conversation_chain(retriever, dataset, query, memory, prompt_template):
    """
    Creates a conversational retrieval chain to answer questions based on the dataset.
    """
    prompt = PromptTemplate(
        input_variables=["history", "question"],  
        template=prompt_template,  
    )

    # Dynamically adjust `k` based on dataset size
    dataset_size = len(dataset)
    k_value = min(10, dataset_size)  # Take up to 10 elements or the entire dataset if smaller

    retriever.search_kwargs = {"k": k_value}  # Use `k_value` instead of a fixed number

    retrieval_chain = RetrievalQA.from_chain_type(
        llm=ChatOpenAI(model="gpt-4-1106-preview", temperature=0.0),
        chain_type='stuff',
        retriever=retriever,
        chain_type_kwargs={
            "prompt": prompt,
            "memory": memory
        }
    )

    response = retrieval_chain.invoke(query)  

    return response['result']
