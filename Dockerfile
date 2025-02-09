# Use official Python image as base
FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Copy the project files into the container
COPY ./daas_py_common/dist /app/daas_py_common/dist
COPY ./daas_py_config/dist /app/daas_py_config/dist
COPY ./daas_py_api/dist /app/daas_py_api/dist

RUN pip install /app/daas_py_common/dist/daas_py_common-0.1.0-py3-none-any.whl
RUN pip install /app/daas_py_config/dist/daas_py_config-0.1.0-py3-none-any.whl
RUN pip install /app/daas_py_api/dist/daas_py_api-0.1.0-py3-none-any.whl

# Extract the package
# RUN tar -xvzf /app/daas_py_config/dist/daas_py_config-0.1.0.tar.gz -C /app \
#     && mv /app/daas_py_config-0.1.0 /app/daas_py_config/
# RUN tar -xvzf /app/daas_py_api/dist/daas_py_api-0.1.0.tar.gz -C /app \
#     && mv /app/daas_py_api-0.1.0 /app/daas_py_api/

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip
#RUN pip install -r requirements.txt

# Ensure Gunicorn is installed
RUN pip install gunicorn  

# Expose the Django port
EXPOSE 8000

# Run migrations and start the Django app
#CMD ["gunicorn", "--bind", "0.0.0.0:8000", "daas_py_api.api.api.wsgi:application"]
CMD ["gunicorn", "--chdir", "/usr/local/lib/python3.11/site-packages/daas_py_api", "--bind", "0.0.0.0:8000", "api.wsgi:application"]

# DEBUGGING CONTAINER
# CMD ["sleep", "infinity"]

# WORKDIR /usr/local/lib/python3.11/site-packages/daas_py_api
#gunicorn --bind 0.0.0.0:8000 api.wsgi:application
#gunicorn --bind 0.0.0.0:8000 api.wsgi:application