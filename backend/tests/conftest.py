import pytest
import sys
import os

# Get the backend directory path
backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Get the flask_api directory path
flask_api_dir = os.path.join(backend_dir, 'flask_api')

# Add both to Python path
sys.path.insert(0, backend_dir)
sys.path.insert(0, flask_api_dir)  # This ensures modules inside flask_api can be found

@pytest.fixture
def app():
    """Create application for the tests."""
    # Now import should work
    from app import app as flask_app
    
    flask_app.config.update({
        "TESTING": True,
    })
    
    return flask_app

@pytest.fixture
def client(app):
    """Create a test client for the app."""
    return app.test_client()