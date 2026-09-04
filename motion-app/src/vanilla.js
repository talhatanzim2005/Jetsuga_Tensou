import { animate } from "motion";

const box = document.getElementById("vanilla-box");

animate(box, { x: 100 }, { duration: 1, repeat: Infinity, direction: "alternate" });
