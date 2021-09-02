FROM python:3.8



WORKDIR /app
COPY ["requirements.txt", "main.py", "./"]
RUN pip install -r requirements.txt
Expose 5000
CMD python main.py
#CMD tail -f /dev/null