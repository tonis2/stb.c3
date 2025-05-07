module stb;

import std::io;

enum Channel : int
{
  STBI_DEFAULT,
  STBI_GREY,
  STBI_GREY_ALPHA,
  STBI_RGB,
  STBI_RGB_ALPHA
}

extern fn char* stbi_load(char*, uint*, uint*, uint*, uint) @extern("stbi_load");
extern fn char* stbi_load_from_memory(char* buffer, uint size, uint* x, uint* y, uint* channels_in_file, uint desired_channels) @extern("stbi_load_from_memory");
extern fn void* stbi_image_free(char*) @extern("stbi_image_free");

faultdef FILE_NOT_FOUND, FILE_NOT_READABLE, BUFFER_NOT_READABLE, FAILED;

struct Image
{
    char* pixels;
    uint height;
    uint width;
    uint size;
    uint index;
    uint channels;
}

fn void Image.free(Image* self) {
    stbi_image_free(self.pixels);
}

fn Image? loadImage(char* file_path, Channel channel) {
  Image data;
  data.pixels = stbi_load(file_path, &data.width, &data.height, &data.channels, (uint)channel.ordinal);

  if (data.pixels == null) {
     io::printfn("Image loading failed");
     return FILE_NOT_FOUND?;
  }

  return data;
}

fn Image? loadFromBuffer(char* buffer, uint size, Channel channel) {
  Image data;
  data.index = 0;
  data.pixels = stbi_load_from_memory(buffer, size, &data.width, &data.height, &data.channels, (uint)channel.ordinal);

  if (data.pixels == null) {
     io::printfn("Image loading failed");
     return BUFFER_NOT_READABLE?;
  }

  return data;
}
