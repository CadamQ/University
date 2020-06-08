let mobilenet;
let video;
let scan;

function setup() {
  /* P5.js Canvas */
  let canvas = createCanvas(640, 480);
  background(0);
  canvas.parent("webcam-canvas");

  /* Webcam Capture */
  video = createCapture(VIDEO);
  video.hide();

  /* Scan Button */
  scan = createButton("Scan")
    .addClass("btn-primary btn-lg")
    .parent("main");
  scan.mousePressed(givePrediction);

  /* Mobilenet Model classifier */
  mobilenet = ml5.imageClassifier("MobileNet", video, () => {
    select("#results").html("Ready for webcam!");
  });
}

function draw() {
  image(video, 0, 0);
}

function givePrediction() {
  mobilenet.predict((err, res) => {
    if (err) {
      console.error(err);
    } else {
      let probability = (res[0].probability * 100).toFixed(1);
      select("#results").html(
        `This is definitely a ${res[0].className}, I'm ${probability}% sure that I'm correct`
      );
    }
  });
}
