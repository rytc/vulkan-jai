/*

Vulkan API bindings.

WARNING: These Vulkan bindings are mostly unused and untested.
This code is here as a starting point for anyone who wants to use Vulkan, but you can expect to do a significant
amount of work to get things going well.

*/

#module_parameters(USE_VULKAN_1_1 := true);  // #import this with USE_VULKAN_1_1 == false if your driver doesn't have those routines.

VK_NULL_HANDLE                    :: null;

VK_TRUE:                   VkBool32: 1;
VK_FALSE:                  VkBool32: 0;

VK_WHOLE_SIZE:             u64: xx ~0;
VK_ATTACHMENT_UNUSED:      u32: 0xffff_ffff;
VK_QUEUE_FAMILY_IGNORED:   u32: 0xffff_ffff;
VK_REMAINING_ARRAY_LAYERS: u32: 0xffff_ffff;
VK_REMAINING_MIP_LEVELS:   u32: 0xffff_ffff;
VK_SUBPASS_EXTERNAL:       u32: 0xffff_ffff;

VK_MAX_PHYSICAL_DEVICE_NAME_SIZE: u32: 256;
VK_UUID_SIZE:                     u32: 16;
VK_MAX_MEMORY_TYPES:              u32: 32;
VK_MAX_MEMORY_HEAPS:              u32: 16;
VK_MAX_EXTENSION_NAME_SIZE:       u32: 256;
VK_MAX_DESCRIPTION_SIZE:          u32: 256;

// These defines are deprecated by vulkan 1.2:
VK_MAKE_VERSION :: (major: u32, minor: u32, patch: u32) -> u32 {
    return (major << 22) | (minor << 12) | patch;
}
VK_VERSION_MAJOR :: (version: u32) -> u32 { return version >> 22; }
VK_VERSION_MINOR :: (version: u32) -> u32 { return (version >> 12) & 0x3ff; }
VK_VERSION_PATCH :: (version: u32) -> u32 { return version & 0xfff; }

VK_API_VERSION_1_0 :: #run VK_MAKE_VERSION(1, 0, 0);
VK_API_VERSION_1_1 :: #run VK_MAKE_VERSION(1, 1, 0);
VK_API_VERSION_1_2 :: #run VK_MAKE_VERSION(1, 2, 0);

// These are the new versions:
VK_MAKE_API_VERSION :: (variant:u32, major: u32, minor: u32, patch: u32) -> u32 {
    return (variant << 22) | (major << 22) | (minor << 12) | patch;
}

VK_API_VERSION_VARIANT :: (version: u32) -> u32 { return (version >> 29); }
VK_API_VERSION_MAJOR   :: (version: u32) -> u32 { return (version >> 22) & 0x3ff; }
VK_API_VERSION_MINOR   :: (version: u32) -> u32 { return (version >> 12) & 0x3ff; }
VK_API_VERSION_PATCH   :: (version: u32) -> u32 { return version & 0xfff; }

#if OS == .WINDOWS {
    #load "generated_windows.jai";
    #load "windows_extras.jai";

    vkCreateWin32SurfaceKHR :: (instance: VkInstance, pCreateInfo: *VkWin32SurfaceCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pSurface: *VkSurfaceKHR) -> VkResult #foreign libvulkan;
    vkGetPhysicalDeviceWin32PresentationSupportKHR :: (physicalDevice: VkPhysicalDevice, queueFamilyIndex: u32) -> VkBool32 #foreign libvulkan;
    #scope_file
    libvulkan :: #library "win/vulkan-1";
} else #if OS == .LINUX {
    #load "generated_linux.jai";
    libvulkan :: #system_library "libvulkan";
}

#scope_module

size_t  :: u64;

