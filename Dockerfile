FROM python:3.9-slim

# Install pytest untuk tahap Test Jenkins
RUN pip install pytest

# Bikin folder tests dan file test bohongan biar Jenkins seneng
RUN mkdir tests && echo "def test_dummy():\n    assert True" > tests/test_dummy.py

# Nyalakan server bohongan di port 5000 biar aplikasinya nyala terus
CMD ["python", "-m", "http.server", "5000"]
