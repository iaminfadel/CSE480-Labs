// Cover Page
#set page(paper: "a4", margin: 1.0cm)
#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true, leading: 0.65em)

#align(center)[
  #image("../assets/ASU_LOGO.png", width: 4cm)
  #v(2cm)

  #text(size: 20pt, weight: "bold")[
    Lab Assignment #02
  ]

  #text(size: 18pt, weight: "bold")[
    Image Processing Techniques:
    Selective Focus and Pencil Sketch Effects
  ]

  #v(1cm)

  #text(size: 14pt, weight: "bold")[
    CSE480: Machine Vision
  ]

  #v(3cm)

  #text(size: 14pt, weight: "bold")[
    Submitted By:
  ]

  #text(size: 14pt)[
    Amin Moustafa Fadel
  ]

  #text(size: 14pt)[
    Student ID: 2100483
  ]

  #v(1.5cm)
  #link("https://github.com/iaminfadel/CSE480-Labs/blob/main/Lab02/Lab02.ipynb")[
    #text(size: 11pt)[Link to GitHub Source Code Repository (Lab02.ipynb)]
  ]

  #v(3cm)
]

#pagebreak()



// Table of Contents
#outline(
  title: [Table of Contents],
  indent: auto,
  depth: 2,
)

#v(2em)

// List of Figures
#outline(
  title: [List of Figures],
  target: figure.where(kind: image),
)

#pagebreak()

// Main Content - Single Column Layout
#set page(
  margin: (left: 1.5cm, right: 1.5cm, top: 2cm, bottom: 2cm),
  columns: 1,
  numbering: "1",
  number-align: center,
  header: context {
    if counter(page).get().first() > 1 [
      #set text(8pt)
      #smallcaps[CSE480 - Lab Assignment #02]
      #h(1fr)
      #counter(page).display("1")
      #line(length: 100%, stroke: 0.5pt)
    ]
  },
)

#set text(size: 10pt)
#set par(justify: true, leading: 0.7em, spacing: 1em)
#set heading(numbering: "1.1")

// Better heading styles
#show heading.where(level: 1): it => {
  v(0.8em)
  block(
    fill: rgb("#e8f4f8"),
    inset: 8pt,
    radius: 3pt,
    width: 100%,
    [
      #set text(size: 12pt, weight: "bold")
      #counter(heading).display()
      #h(0.5em)
      #it.body
    ],
  )
  v(0.8em)
}

#show heading.where(level: 2): it => {
  v(0.6em)
  block(
    inset: (left: 6pt),
    [
      #set text(size: 10pt, weight: "bold")
      #counter(heading).display()
      #h(0.5em)
      #it.body
    ],
  )
  v(0.4em)
}

// Key insight boxes
#let insight(content) = {
  block(
    fill: rgb("#eff6ff"),
    stroke: (left: 2pt + rgb("#3b82f6")),
    inset: 8pt,
    radius: 2pt,
    width: 100%,
    [
      #set text(size: 8.5pt)
      *Key Insight:* #content
    ],
  )
}

= Task 1: Portrait Mode Filter

In this task, the goal is to create an image filter that mimics a smartphone's portrait mode. The subject in the foreground is maintained in sharp focus, while the background is artistically blurred to simulate a shallow depth of field.

== Methodology & Implementation

The effect was accomplished through a series of masking and spatial filtering operations:

1. *Mask Generation:* An elliptical mask was programmatically created to encompass the central subject. Inside the ellipse, pixel values were set to `0` (black), while the outside was set to `255` (white). To facilitate logical extraction, an inverted copy of this mask was generated, mapping the subject area to white.
2. *Background Blurring:* A heavily blurred duplicate of the original image was synthesized using a Gaussian Blur filter configured with a large kernel size matrix `(51x51)`.
3. *Logical Bitwise Extraction:*
  - The *sharp subject* was isolated by evaluating a logical `bitwise_and` operation between the original image matrices, conditionally restricted by the inverted mask.
  - The *blurred background* was extracted symmetrically, executing `bitwise_and` across the blurred image matrices restricted by the original mask.
4. *Matrix Recombination:* The two isolated component matrices were converged via a logical `bitwise_or` function to produce the final selective focus composite.

== Results

#figure(
  grid(
    columns: 2,
    gutter: 10pt,
    image("person_with_background.jpg", width: 100%), image("task1_mask.jpg", width: 100%),
  ),
  caption: [Left: Original Image. Right: Extracted Elliptical Mask (Background represented as white).],
) <fig:task1_steps>

#figure(
  image("task1_result.jpg", width: 80%),
  caption: [Final Result: Selective Focus (Portrait Mode effect merging sharp subject masks and gaussian blurred surrounds).],
) <fig:task1_final>

#pagebreak()

= Task 2: Pencil Sketch Effect

This assignment translates a standard photographic portrait into a stylistic pencil-sketch illustration. Two different computational approaches were examined and evaluated: approximation of the "Color Dodge" analytical blend mode, and mathematical edge detection using the Canny operator.

== Methodology & Implementation

1. *Pre-Processing (Invert & Blur):* The input color domain was converted to a single-channel grayscale representation. This matrix was conceptually inverted utilizing `bitwise_not` geometry and aggressively smoothed via a Gaussian kernel sized `(21x21)`.
2. *Color Dodge Approximation:* The primary sketch aesthetic was rendered by computationally evaluating the "Color Dodge" blend equivalent. In the OpenCV API, this was functionally modeled utilizing a divided matrix scale operation: `cv2.divide(gray_img, 255 - blurred_inverted, scale=256)`.
3. *Alternative Canny Extraction:* To establish an analytical baseline, a Canny edge detector (`threshold1=30, threshold2=100`) was applied against the grayscale input. The resulting edge detection map (white lines transposed onto a black void) was inverted to establish dark contour lines on a white canvas space, mirroring an unshaded technical blueprint.

== Results & Comparison

#figure(
  image("portrait.jpg", width: 55%),
  caption: [Original Portrait Image.],
) <fig:task2_orig>

#figure(
  grid(
    columns: 2,
    gutter: 10pt,
    image("task2_dodge.jpg", width: 100%), image("task2_canny.jpg", width: 100%),
  ),
  caption: [Left: Pencil Sketch via mathematically modeled Color Dodge Blend. Right: Unshaded Pencil Sketch utilizing inverted Canny Edge Operator vectors.],
) <fig:task2_sketches>

#insight[
  *Comparative Analysis of Outputs:*
  Comparing the dual outputs highlights distinct functional characteristics.
  - The *Color Dodge methodology* yields an organically shaded, softer composition incorporating varying gradients of gray pixel intensity. It authentically replicates the artistic stroke volume inherent in traditional hand-drawn graphite portraits.
  - The *Canny Edges methodology* produces absolute binary vectors—harsh and intensely precise. It inherently lacks shading volume and topological gradient information, making it structurally ideal for topological parameter extraction or blueprint mapping, but visually inferior for mimicking traditional aesthetic art lines.
]
