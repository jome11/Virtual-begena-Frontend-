window.playAudio = function (path) {
  const audio = new Audio(path);
  audio.play().catch(() => {});
};
