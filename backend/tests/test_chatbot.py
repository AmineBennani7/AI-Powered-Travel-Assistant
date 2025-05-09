import unittest
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from chatbot_main_nomic import detect_csv_from_query

class ChatbotTest(unittest.TestCase):
    def test_detect_csv_from_query(self):
        """Test CSV detection from query"""
        
        # Test restaurant queries
        restaurant_queries = [
            "What are some good restaurants in Oxford?",
            "I'm looking for dining options",
            "Can you recommend a restaurant for dinner?"
        ]
        for query in restaurant_queries: # Check if "restaurants" appears in the path for the all test cases
            self.assertIn("restaurants", detect_csv_from_query(query)) #Check if the path contains "restaurants"
            
        # Test pub queries
        pub_queries = [
            "Where can I find a good pub?",
            "Best bars in the city center?",
            "Any nightclubs in Oxford?"
        ]
        for query in pub_queries: # Check if "pubs" appears in the path for the all test cases
            self.assertIn("pubs", detect_csv_from_query(query)) #Check if the path contains "pubs"
            
        # Test general queries
        general_queries = [
            "What can I do in Oxford?",
            "Tell me about Oxford",
            "I need a place for drinks",
            "I'm visiting Oxford tomorrow"
        ]
        for query in general_queries: # Check if "combined" appears in the path for the all test cases
            self.assertIn("combined", detect_csv_from_query(query)) #Check if the path contains "combined"

if __name__ == '__main__':
    unittest.main()