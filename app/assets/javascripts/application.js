//= require_tree .

const dont_call_me_white = document.querySelector(".white")
if (dont_call_me_white) {
  if (dont_call_me_white.innerHTML.trim().length === 0) {
    dont_call_me_white.remove();
  }
}