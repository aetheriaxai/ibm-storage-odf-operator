#!/bin/bash
#
# Copyright contributors to the ibm-storage-odf-operator project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


set -e

DEFAULT_YQ_VERSION="4.8.0"
DEFAULT_OPM_VERSION="v1.17.0"
DEFAULT_OPERATOR_SDK_VERSION="v1.5.0"
DEFAULT_KUSTOMIZE_VERSION="v3.8.7"
DEFAULT_FLASHSYSTEM_DRIVER_RELEASE="v0.0.22"

# Check IBM block storage CSI driver versions on https://www.ibm.com/docs/en/blockstg-csi-driver
DEFAULT_BLOCK_CSI_RELEASE="v1.5.0"
DEFAULT_BLOCK_CSI_CR_FILE="csi.ibm.com_v1_ibmblockcsi_cr.yaml"

VCS_URL="https://github.com/IBM/ibm-storage-odf-operator"
VCS_REF="0.2.0-$(git rev-parse --short HEAD)"
RELEASE_VERSION=$(cat version/version.go | grep "Version =" | awk -F '"' '{print $2}')

CHANNELS="stable-v1"
DEFAULT_CHANNEL="stable-v1"

GO111MODULE="on"
GOPROXY="https://proxy.golang.org"
GOROOT="${GOROOT:-go env GOROOT}"
GOOS="${GOOS:-linux}"
GOARCH="${GOARCH:-amd64}"

OCS_OC_PATH="${OCS_OC_PATH:-oc}"
OUTDIR="build/_output"
OUTDIR_BIN="${OUTDIR}/bin"
BUNDLE_MANIFESTS_DIR="bundle/manifests"
BUNDLE_METADATA_DIR="bundle/metadata"
CSV_PATH="${BUNDLE_MANIFESTS_DIR}/ibm-storage-odf-operator.clusterserviceversion.yaml"

LOCAL_OS_TYPE=$(uname)

YQ_PLATFORM="linux_amd64"
OPM_PLATFORM="linux-amd64-opm"
OPERATOR_SDK_PLATFORM="linux_amd64"
KUSTOMIZE_PLATFORM="linux_amd64"

DEFAULT_YQ_BIN="${OUTDIR_BIN}/yq"
DEFAULT_OPM_BIN="${OUTDIR_BIN}/opm"
DEFAULT_OPERATOR_SDK_BIN="${OUTDIR_BIN}/operator-sdk"
DEFAULT_KUSTOMIZE_BIN="${OUTDIR_BIN}/kustomize"

DEFAULT_IMAGE_REGISTRY="docker.io"
DEFAULT_REGISTRY_NAMESPACE="ibmcom"
DEFAULT_IMAGE_TAG="latest"
DEFAULT_OPERATOR_IMAGE_NAME="ibm-storage-odf-operator"
DEFAULT_OPERATOR_BUNDLE_NAME="ibm-storage-odf-operator-bundle"
DEFAULT_CATALOG_IMAGE_NAME="ibm-storage-odf-catalog"
DEFAULT_MUST_GATHER_IMAGE_NAME="ibm-storage-odf-operator-must-gather"
DEFAULT_FLASHSYSTEM_DRIVER_NAME="ibm-storage-odf-block-driver"

YQ_BIN="${YQ_BIN:-${DEFAULT_YQ_BIN}}"
OPM_BIN="${OPM_BIN:-${DEFAULT_OPM_BIN}}"
YQ_VERSION="${YQ_VERSION:-${DEFAULT_YQ_VERSION}}"
OPM_VERSION="${OPM_VERSION:-${DEFAULT_OPM_VERSION}}"
OPERATOR_SDK_VERSION="${OPERATOR_SDK_VERSION:-${DEFAULT_OPERATOR_SDK_VERSION}}"
OPERATOR_SDK_BIN="${OPERATOR_SDK_BIN:-${DEFAULT_OPERATOR_SDK_BIN}}"
KUSTOMIZE_VERSION="${KUSTOMIZE_VERSION:-${DEFAULT_KUSTOMIZE_VERSION}}"
KUSTOMIZE_BIN="${KUSTOMIZE_BIN:-${DEFAULT_KUSTOMIZE_BIN}}"
BLOCK_CSI_RELEASE="${BLOCK_CSI_RELEASE:-${DEFAULT_BLOCK_CSI_RELEASE}}"
BLOCK_CSI_CR_FILE="${BLOCK_CSI_CR_FILE:-${DEFAULT_BLOCK_CSI_CR_FILE}}"
FLASHSYSTEM_DRIVER_RELEASE="${FLASHSYSTEM_DRIVER_RELEASE:-${DEFAULT_FLASHSYSTEM_DRIVER_RELEASE}}"

BUNDLE_CHANNELS="${BUNDLE_CHANNELS:---channels=${CHANNELS}}"
BUNDLE_DEFAULT_CHANNEL="${BUNDLE_DEFAULT_CHANNEL:---default-channel=${DEFAULT_CHANNEL}}"
IMAGE_REGISTRY="${IMAGE_REGISTRY:-${DEFAULT_IMAGE_REGISTRY}}"
REGISTRY_NAMESPACE="${REGISTRY_NAMESPACE:-${DEFAULT_REGISTRY_NAMESPACE}}"
IMAGE_TAG="${IMAGE_TAG:-${DEFAULT_IMAGE_TAG}}"
OPERATOR_IMAGE_NAME="${OPERATOR_IMAGE_NAME:-${DEFAULT_OPERATOR_IMAGE_NAME}}"
OPERATOR_BUNDLE_NAME="${OPERATOR_BUNDLE_NAME:-${DEFAULT_OPERATOR_BUNDLE_NAME}}"
OPERATOR_INDEX_NAME="${OPERATOR_INDEX_NAME:-${DEFAULT_OPERATOR_INDEX_NAME}}"
CATALOG_IMAGE_NAME="${CATALOG_IMAGE_NAME:-${DEFAULT_CATALOG_IMAGE_NAME}}"
FLASHSYSTEM_DRIVER_NAME="${FLASHSYSTEM_DRIVER_NAME:-${DEFAULT_FLASHSYSTEM_DRIVER_NAME}}"
OPERATOR_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${OPERATOR_IMAGE_NAME}:${VCS_REF}"
BUNDLE_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${OPERATOR_BUNDLE_NAME}:${RELEASE_VERSION}"
CATALOG_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${CATALOG_IMAGE_NAME}:${IMAGE_TAG}"
MUST_GATHER_IMAGE_NAME="${MUST_GATHER_IMAGE_NAME:-${DEFAULT_MUST_GATHER_IMAGE_NAME}}"
MUST_GATHER_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${MUST_GATHER_IMAGE_NAME}:${IMAGE_TAG}"
FLASHSYSTEM_DRIVER_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${FLASHSYSTEM_DRIVER_NAME}:${FLASHSYSTEM_DRIVER_RELEASE}"