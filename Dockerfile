FROM --platform=$BUILDPLATFORM golang:1.26-alpine AS build
RUN apk upgrade --no-cache --force
ADD go.mod go.sum .
RUN go mod download
COPY . .
RUN go build -o garage-metrics-exporter cmd/main.go

FROM gcr.io/distroless/static
COPY --from=build /go/garage-metrics-exporter /
USER 1000:1000
EXPOSE 3905
CMD ["/garage-metrics-exporter"]
