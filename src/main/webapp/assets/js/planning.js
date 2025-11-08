/**
 * Navigate to previous or next month
 * @param {number} offset - Month offset (-1 for previous, 1 for next)
 */
function navigateMonth(offset) {
  const currentOffset = Number.parseInt(
    document.querySelector("[data-current-offset]")?.getAttribute("data-current-offset") || "0",
  )
  const newOffset = currentOffset + offset
  const url = new URL(window.location.href)
  url.searchParams.set("monthOffset", newOffset)
  window.location.href = url.toString()
}

/**
 * View consultation details
 * @param {number} consultationId - Consultation ID
 */
function viewConsultation(consultationId) {
  if (consultationId) {
    window.location.href = `/docteur/consultation-details?id=${consultationId}`
  }
}

/**
 * Initialize consultation item click handlers
 */
function initializeConsultationItems() {
  document.querySelectorAll(".consultation-item").forEach((item) => {
    item.addEventListener("click", function (e) {
      e.stopPropagation()
      if (!this.classList.contains("cancelled")) {
        const consultationId = this.getAttribute("data-consultation-id")
        viewConsultation(consultationId)
      }
    })
  })
}

/**
 * Initialize calendar day hover effects
 */
function initializeCalendarDays() {
  document.querySelectorAll(".calendar-day").forEach((day) => {
    day.addEventListener("mouseenter", function () {
      this.style.transition = "all 0.3s ease"
    })
  })
}

// Initialize all functionality when DOM is ready
document.addEventListener("DOMContentLoaded", () => {
  initializeConsultationItems()
  initializeCalendarDays()
})
