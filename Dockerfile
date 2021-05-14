# Build the manager binary
FROM golang:1.15 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY main.go main.go
COPY api/ api/
COPY controllers/ controllers/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o manager main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
MAINTAINER IBM Storage

ARG VCS_REF
ARG VCS_URL

LABEL vendor="IBM" \
  name="ibm-storage-odf-operator" \
  org.label-schema.vendor="IBM" \
  org.label-schema.name="ibm storage odf operator" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url=$VCS_URL \
  org.label-schema.license="Licensed Materials - Property of IBM" \
  org.label-schema.schema-version="0.1.0"

WORKDIR /
COPY --from=builder --chown=nonroot /workspace/manager /manager
# COPY RULES
COPY /rules/*.yaml /prometheus-rules/
USER nonroot:nonroot

ENTRYPOINT ["/manager"]
