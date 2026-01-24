# Image Resizer Script

A simple bash project to resize images to a specific target file size (in KB) using ImageMagick. Designed for Kali Linux.

## Files

- `install_dependencies.sh`: Installs ImageMagick.
- `resize_image.sh`: The main script to resize images.

## Usage

1.  **Install Dependencies**:
    ```bash
    sudo ./install_dependencies.sh
    ```

2.  **Resize an Image**:
    ```bash
    ./resize_image.sh <input_image> <target_size_kb>
    ```
    
    Example: reduce `photo.jpg` to 250KB:
    ```bash
    ./resize_image.sh photo.jpg 250
    ```
