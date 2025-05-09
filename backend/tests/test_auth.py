import unittest
import json
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from flask_api.app import app

class AuthTest(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True
        
    def test_register_validation(self):
        """Test input validation on registration"""
        # Test with missing email
        response = self.app.post('/register',
                                data=json.dumps({
                                    'first_name': 'Test',
                                    'last_name': 'User',
                                    # email missing
                                    'phone_number': '+44123456789',
                                    'password': 'Password123!'
                                }),
                                content_type='application/json')
        data = json.loads(response.data)
        self.assertEqual(response.status_code, 400)
        self.assertFalse(data['success'])
        self.assertIn('required', data['message'].lower())
        
    def test_login_validation(self):
        """Test input validation on login"""
        # Test with missing password
        response = self.app.post('/login',
                                data=json.dumps({
                                    'email': 'test@example.com',
                                    # password missing
                                }),
                                content_type='application/json')
        data = json.loads(response.data)
        self.assertEqual(response.status_code, 400)
        self.assertFalse(data['success'])

if __name__ == '__main__':
    unittest.main()