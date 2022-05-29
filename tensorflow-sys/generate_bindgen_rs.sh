#!/bin/sh

if ! which bindgen > /dev/null; then
    echo "ERROR: Please install 'bindgen' using cargo:"
    echo "    cargo install bindgen"
    echo "See https://github.com/servo/rust-bindgen for more information."
    exit 1
fi

include_dir="$HOME/git/tensorflow"

bindgen_options_c_api="--allowlist-function TF_.+ --allowlist-type TF_.+ --allowlist-var TF_.+ --size_t-is-usize --default-enum-style=rust --generate-inline-functions"
cmd="bindgen ${bindgen_options_c_api} ${include_dir}/tensorflow/c/c_api.h --output src/c_api.rs --  -I ${include_dir}"
echo ${cmd}
${cmd}

bindgen_options_eager="--allowlist-function TFE_.+ --allowlist-type TFE_.+ --allowlist-var TFE_.+ --blocklist-type TF_.+ --size_t-is-usize --default-enum-style=rust --generate-inline-functions"
cmd="bindgen ${bindgen_options_eager} ${include_dir}/tensorflow/c/eager/c_api.h --output src/eager/c_api.rs --  -I ${include_dir}"
echo ${cmd}
${cmd}

bindgen_options_runtime_functions="--allowlist-function TF_.+ --blocklist-type .+ --size_t-is-usize --default-enum-style=rust --generate-inline-functions"
cmd="bindgen ${bindgen_options_runtime_functions} ${include_dir}/tensorflow/c/c_api.h --output src/runtime_linking/c_api.rs --  -I ${include_dir}"
echo ${cmd}
${cmd}

bindgen_options_runtime_types="--allowlist-type TF_.+ --blocklist-function .+ --size_t-is-usize --default-enum-style=rust --generate-inline-functions"
cmd="bindgen ${bindgen_options_runtime_types} ${include_dir}/tensorflow/c/c_api.h --output src/runtime_linking/types.rs --  -I ${include_dir}"
echo ${cmd}
${cmd}

bindgen_options_stream_executor="--allowlist-function SE_.+ --blocklist-type (TF_.+|__.+) --size_t-is-usize --default-enum-style=rust --generate-inline-functions"
cmd="bindgen ${bindgen_options_stream_executor} ${include_dir}/tensorflow/c/experimental/stream_executor/stream_executor.h --output src/stream_executor/stream_executor.rs --  -I ${include_dir}"
echo ${cmd}
${cmd}

bindgen_options_kernels="--allowlist-type (TF_KernelBuilder|TF_OpKernelConstruction|TF_OpKernelContext) --blocklist-type (TF_DataType|TF_Status|TF_AllocatorAttributes|TF_Tensor|TF_StringView|__.+) --allowlist-function (TF_OpKernelConstruction_.+|TF_AllocateOutput|TF_ForwardInputOrAllocateOutput|TF_AllocateTemp) --size_t-is-usize --default-enum-style=rust --generate-inline-functions"
cmd="bindgen ${bindgen_options_kernels} ${include_dir}/tensorflow/c/kernels.h --output src/kernels/kernels.rs --  -I ${include_dir}"
echo ${cmd}
${cmd}

bindgen_options_kernels_experimental="--blocklist-file .*/tensorflow/c/(tf_status|tf_datatype|tf_tensor|tf_tstring|c_api|kernels)\.h --blocklist-type (TF_AttrType|TF_TString.*|SP_Stream.*|__.+) --allowlist-function TF_.+ --size_t-is-usize --default-enum-style=rust --generate-inline-functions"
cmd="bindgen ${bindgen_options_kernels_experimental} ${include_dir}/tensorflow/c/kernels_experimental.h --output src/kernels/kernels_experimental.rs --  -I ${include_dir}"
echo ${cmd}
${cmd}

echo "link! {\n$(cat src/runtime_linking/c_api.rs)" > src/runtime_linking/c_api.rs
echo } >> src/runtime_linking/c_api.rs
