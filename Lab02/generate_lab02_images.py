import cv2
import numpy as np
import os

# Ensure we're working in the correct directory
abs_path = r"c:\Users\rocke\Desktop\CSE480s\Labs\CSE480-Labs\Lab02"
os.chdir(abs_path)

# --- Task 1 ---
img1 = cv2.imread('person_with_background.jpg')
if img1 is not None:
    mask = np.ones(img1.shape[:2], dtype=np.uint8) * 255
    center = (img1.shape[1] // 2, int(img1.shape[0] // 2.5))
    axes = (img1.shape[1] // 5, int(img1.shape[0] // 3.5))
    cv2.ellipse(mask, center, axes, 0, 0, 360, 0, -1)
    
    mask_subject = cv2.bitwise_not(mask)
    blurred_img = cv2.GaussianBlur(img1, (51, 51), 0)
    
    sharp_subject = cv2.bitwise_and(img1, img1, mask=mask_subject)
    blurred_background = cv2.bitwise_and(blurred_img, blurred_img, mask=mask)
    selective_focus_img = cv2.bitwise_or(sharp_subject, blurred_background)
    
    cv2.imwrite('task1_mask.jpg', mask)
    cv2.imwrite('task1_result.jpg', selective_focus_img)
    print("Task 1 images generated successfully.")
else:
    print("Could not load person_with_background.jpg")

# --- Task 2 ---
img2 = cv2.imread('portrait.jpg')
if img2 is not None:
    gray_img = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)
    inverted_img = cv2.bitwise_not(gray_img)
    blurred_inverted = cv2.GaussianBlur(inverted_img, (21, 21), 0)
    
    # Division with generic scaling
    sketch_color_dodge = cv2.divide(gray_img, 255 - blurred_inverted, scale=256)
    
    edges = cv2.Canny(gray_img, 30, 100)
    sketch_canny = cv2.bitwise_not(edges)
    
    cv2.imwrite('task2_dodge.jpg', sketch_color_dodge)
    cv2.imwrite('task2_canny.jpg', sketch_canny)
    print("Task 2 images generated successfully.")
else:
    print("Could not load portrait.jpg")
