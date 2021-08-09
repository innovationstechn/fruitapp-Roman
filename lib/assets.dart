// This file contains the paths of the assets that are used throughout the app,
// as well as their descriptions.
// Since thse are static and are not that many, we can just store them like this.

// For easily switching between GIF and PNG modes.
enum CarouselMode { GIF, PNG }

final basePath = "assets/fruits/";
final assetMode = CarouselMode.GIF;

// These are 3 placeholder descriptions of the fruits.
final dummyDescription1 =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book";
final dummyDescription2 =
    "Pellentesque venenatis ex sit amet porta faucibus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Fusce porta, ligula eu tincidunt dapibus, mauris purus sollicitudin ex, sed placerat libero ligula sit amet turpis. ";
final dummyDescription3 =
    "Duis id tortor ac nunc aliquet vestibulum. Donec bibendum lorem vitae nulla commodo, at fermentum metus dictum. Pellentesque nec lorem quam.";

// The paths of fruits, where their default images are in [image], and the
// the paths of different colors are in [variants] key, as well as the
// [description]s of each fruit varient.
final Map details = {
  "watermelon": {
    "image": "watermelon/1.png",
    "variants": {
      "red": "1",
      "white": "2",
      "green": "3",
      "grey": "4",
      "black": "5",
      "blue": "6",
      "orange": "7",
      "yellow": "8"
    },
    "description": {
      "red": dummyDescription1,
      "white": dummyDescription2,
      "green": dummyDescription3,
      "grey": dummyDescription1,
      "black": dummyDescription2,
      "blue": dummyDescription3,
      "orange": dummyDescription1,
      "yellow": dummyDescription2
    },
  },
  "apple": {
    "image": "apple/1.png",
    "variants": {
      "red": "1",
      "white": "2",
      "green": "4",
      "grey": "8",
      "black": "5",
      "blue": "7",
      "orange": "6",
      "yellow": "3"
    },
    "description": {
      "red": dummyDescription1,
      "white": dummyDescription2,
      "green": dummyDescription3,
      "grey": dummyDescription1,
      "black": dummyDescription2,
      "blue": dummyDescription3,
      "orange": dummyDescription1,
      "yellow": dummyDescription2
    },
  },
  "banana": {
    "image": "banana/1.png",
    "variants": {
      "red": "6",
      "white": "4",
      "green": "5",
      "grey": "7",
      "black": "3",
      "blue": "8",
      "orange": "2",
      "yellow": "1"
    },
    "description": {
      "red": dummyDescription1,
      "white": dummyDescription2,
      "green": dummyDescription3,
      "grey": dummyDescription1,
      "black": dummyDescription2,
      "blue": dummyDescription3,
      "orange": dummyDescription1,
      "yellow": dummyDescription2
    },
  },
  "pear": {
    "image": "pear/1.png",
    "variants": {
      "red": "2",
      "white": "6",
      "green": "1",
      "grey": "7",
      "black": "3",
      "blue": "8",
      "orange": "5",
      "yellow": "4"
    },
    "description": {
      "red": dummyDescription1,
      "white": dummyDescription2,
      "green": dummyDescription3,
      "grey": dummyDescription1,
      "black": dummyDescription2,
      "blue": dummyDescription3,
      "orange": dummyDescription1,
      "yellow": dummyDescription2
    },
  },
};
