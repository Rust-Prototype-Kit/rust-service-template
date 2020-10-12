FROM rust:1.44 as builder
RUN USER=root cargo new --bin micro-service 
WORKDIR ./micro-service
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release
RUN rm src/*.rs

ADD . ./

RUN rm ./target/release/deps/micro-service*
RUN cargo build --release

ENV TZ=Etc/UTC \
    APP_USER=appuser

FROM debian:buster-slim
ARG APP=/usr/src/app
EXPOSE 8000

COPY --from=builder /micro-service/target/release/micro-service ${APP}/micro-service

WORKDIR ${APP} 
CMD ["./micro-service"]
