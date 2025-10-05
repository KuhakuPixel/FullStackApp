
import requests
import json
# Base URL of the running Flask application
# IMPORTANT: The Flask app must be running on this address for these tests to work.
BASE_URL = "http://127.0.0.1:3000"

def test_1_limit_query_results_in_exact_number():
    """
    Tests if the 'limit' query parameter correctly restricts the number of results.
    """
    test_limit = 12 
    endpoint = f"/products?limit={test_limit}"
    response = requests.get(BASE_URL + endpoint)
    assert response.status_code == 200, f"Expected 200 status code, got {response.status_code}"
    
    try:
        data = response.json()
        # Check if the number of returned products matches the specified limit
        assert len(data['products']) == test_limit, \
               f"Expected {test_limit} products, but got {len(data['products'])}"
    except json.JSONDecodeError:
        assert False, "Response could not be decoded as JSON."

def test_2_high_page_results_in_no_results():
    """
    Tests if a page number far beyond the total page count returns an empty list.
    """
    high_page = 9999999
    # Use a reasonable limit to ensure that high_page is truly out of bounds
    endpoint = f"/products?page={high_page}&limit=10"
    response = requests.get(BASE_URL + endpoint)
    assert response.status_code == 200, f"Expected 200 status code, got {response.status_code}"
    
    try:
        data = response.json()
        # The list of products should be empty
        assert len(data['products']) == 0, \
               f"Expected 0 products for page {high_page}, but got {len(data['products'])}"
    except json.JSONDecodeError:
        assert False, "Response could not be decoded as JSON."

def test_3_exclusion_of_ids_works_correctly():
    """
    Tests if the 'exclude_ids' filter successfully removes the specified IDs.
    We exclude IDs 1 through 5.
    """
    # The IDs to exclude must be passed as a JSON string in the URL
    exclude_ids = [1, 2, 3, 4, 5]
    exclude_ids_json = json.dumps(exclude_ids)
    
    # Request a large limit to ensure we capture the first few products
    endpoint = f"/products?exclude_ids={exclude_ids_json}&limit=20"
    response = requests.get(BASE_URL + endpoint)
    assert response.status_code == 200, f"Expected 200 status code, got {response.status_code}"
    
    try:
        data = response.json()
        returned_products = data['products']
        
        # Extract the IDs of the returned products
        returned_ids = {p['id'] for p in returned_products}
        
        # Check that none of the excluded IDs are present
        for excluded_id in exclude_ids:
            assert excluded_id not in returned_ids, \
                   f"Product ID {excluded_id} was found in the results despite being excluded."
            
        # Sanity check: Ensure the list is not empty
        assert len(returned_products) > 0, "No products were returned after exclusion"
        
    except json.JSONDecodeError:
        assert False, "Response could not be decoded as JSON."
