
class Mover {

  // The Mover tracks location, velocity, and acceleration 
  PVector location;
  PVector end;
  PVector velocity;
  PVector acceleration;
  // The Mover's maximum speed
  float topspeed;


  Mover(PVector location_, PVector end_, PVector velocity_) {
    // Start in the center
    location = location_;
    end = end_;
    velocity = velocity_;
    acceleration= new PVector(0, 0);
  }

  void update() {

    // Compute a vector that points from location to mouse
    acceleration = PVector.sub(end, location);
    // Set magnitude of acceleration
    acceleration.normalize();
    acceleration.mult(0.1);

    // Velocity changes according to acceleration
    velocity.add(acceleration);
    location.add(velocity);
  }

  void display() {
    noStroke();
    fill(198, 224, 112);
    ellipse(location.x, location.y, 8, 8);
  }
}

