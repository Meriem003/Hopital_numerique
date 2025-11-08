// Medical History Page - JavaScript Functions

function applyFilter() {
  const annee = document.getElementById("anneeFilter").value
  const specialite = document.getElementById("specialiteFilter").value

  let url = window.location.pathname + "?"
  const params = []

  if (annee) {
    params.push("annee=" + encodeURIComponent(annee))
  }
  if (specialite) {
    params.push("specialite=" + encodeURIComponent(specialite))
  }

  url += params.join("&")
  window.location.href = url
}

function resetFilters() {
  window.location.href = window.location.pathname
}

// Animation au chargement
document.addEventListener("DOMContentLoaded", () => {
  const timelineItems = document.querySelectorAll(".timeline-item")
  timelineItems.forEach((item, index) => {
    item.style.opacity = "0"
    item.style.transform = "translateY(20px)"

    setTimeout(() => {
      item.style.transition = "all 0.5s cubic-bezier(0.4, 0, 0.2, 1)"
      item.style.opacity = "1"
      item.style.transform = "translateY(0)"
    }, index * 100)
  })
})
