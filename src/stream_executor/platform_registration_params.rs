use tensorflow_sys as tf;
use std::ffi::CString;
use std::ffi::NulError;

#[derive(Debug)]
pub struct PlatformRegistrationParams {
    inner: *mut tf::SE_PlatformRegistrationParams,
}

impl PlatformRegistrationParams {
    pub fn set_version(&mut self, major_version: i32, minor_version: i32, patch_version: i32) {
        unsafe {
            (*self.inner).major_version = major_version;
            (*self.inner).minor_version = minor_version;
            (*self.inner).patch_version = patch_version;
        }
    }

    pub fn set_platform_name(&mut self, platform_name: &str) -> std::result::Result<(), NulError> {
        unsafe {
            let platform_name_cstring = CString::new(platform_name)?;
            (*(*self.inner).platform).name = platform_name_cstring.as_ptr();
        }
        Ok(())
    }

    pub fn set_platform_type(&mut self, platform_type: &str) -> std::result::Result<(), NulError> {
        unsafe {
            let platform_type_cstring = CString::new(platform_type)?;
            (*(*self.inner).platform).type_ = platform_type_cstring.as_ptr();
        }
        Ok(())
    }

    pub fn set_supports_unified_memory(&mut self, supports_unified_memory: bool) {
        unsafe {
            (*(*self.inner).platform).supports_unified_memory = supports_unified_memory as u8;
        }
    }

    pub fn set_use_bfc_allocator(&mut self, use_bfc_allocator: bool) {
        unsafe {
            (*(*self.inner).platform).use_bfc_allocator = use_bfc_allocator as u8;
        }
    }

    pub fn set_force_memory_growth(&mut self, force_memory_growth: bool) {
        unsafe {
            (*(*self.inner).platform).force_memory_growth = force_memory_growth as u8;
        }
    }
}