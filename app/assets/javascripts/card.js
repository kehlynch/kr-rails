function cardImagePath(slug, landscape) {
  return landscape ? `/assets/images/${slug}_landscape.jpg` : `/assets/images/${slug}.jpg`;
}
