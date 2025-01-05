class Color:
    def __init__(self, value):
        self.value = value


# Define your background colors as RGB tuples
backgroundColors = [
    (0x0D, 0x47, 0xA1),  # blue[900]
    (0x1B, 0x5E, 0x20),  # green[900]
    (0xB7, 0x1C, 0x1C),  # red[900]
    (0xF5, 0x7F, 0x17),  # yellow[900]
    (0x4A, 0x14, 0x8C),  # purple[900]
    (0x1A, 0x23, 0x7E),  # indigo[900]
    (0x00, 0x4D, 0x40),  # teal[900]
    (0x3E, 0x27, 0x23),  # brown[900]
    (0x7F, 0x7E, 0x7E),  # grey[900]
    (0x88, 0x0E, 0x4F),  # pink[900]
]


def getColorFromId(id):
    index = hash(id) % len(backgroundColors)
    if index < 0:
        index = -index  # Ensure index is positive
    color_rgb = backgroundColors[index]
    color_argb_int = rgb_to_argb_int(color_rgb)
    return color_argb_int


def rgb_to_argb_int(rgb):
    # Assuming alpha value of 0xFF (fully opaque)
    return (0xFF << 24) | (rgb[0] << 16) | (rgb[1] << 8) | rgb[2]


def main():
    # Use the function to get the color integer for a specific ID
    color_int = getColorFromId("some_unique_id")
    print(color_int)  # This will print the integer ARGB value of the color


if __name__ == "__main__":
    main()
