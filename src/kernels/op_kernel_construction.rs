use crate::Status;
use tensorflow_sys as tf;

#[derive(Debug)]
pub struct OpKernelConstruction {
    inner: *mut tf::TF_OpKernelConstruction,
}

impl OpKernelConstruction {
    /// Sets the OpKernelConstruction to a failure status
    pub fn set_failure(&mut self, status: Status) {
        unsafe {
            tf::TF_OpKernelConstruction_Failure(
                self.inner,
                status.inner,
            );
        }
    }
}
