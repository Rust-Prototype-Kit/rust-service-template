FROM rust:1.43 as builder

WORKDIR /opt/micro-service
COPY . .
RUN cargo build --release

FROM debian:buster-slim
ARG APP=/usr/src/app

COPY --from=builder /opt/micro-service/target/release/micro-service /opt/micro-service
WORKDIR /opt/micro-service/target/release/ 

CMD ["./micro-service"]

EXPOSE 8080