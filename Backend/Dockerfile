FROM python:3.13.0rc1-bookworm
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 5000
CMD python ./main.py
