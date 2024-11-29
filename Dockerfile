FROM golang:1.23.3-alpine3.20

WORKDIR /app

COPY ./api .

RUN go mod tidy

RUN go build -o main .

EXPOSE 3000

CMD ["./main"]
