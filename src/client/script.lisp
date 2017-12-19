(defpackage #:bow-person.client.script
  (:use #:cl #:parenscript)
  (:export #:homepage))
(in-package #:bow-person.client.script)

(defun script-js (params)
  (declare (ignore params))
  (ps-to-stream
   *standard-output*

   ;;; global variables

   ;; common
   (defvar scene)
   (defvar clock)
   (defvar camera)
   (defvar controls)
   (defvar renderer)

   ;; scene-dependent
   (defvar cube)


   ;;; function definitions

   ;; initialize state
   (defun init ()
     ;; create scene
     (setf scene (new (chain *three* (*scene))))
     ;; create clock
     (setf clock (new (chain *three* *clock)))
     ;; create camera
     (setf camera (new (chain *three* (*perspective-camera 75 ; FOV (degrees)
                                                             ;; aspect ratio
                                                             (/ (@ window inner-width)
                                                                (@ window inner-height))
                                                             ;; near
                                                             0.1
                                                             ;; far
                                                             1000))))
     ;; create controls
     (let ((blocker (chain document (get-element-by-id "blocker")))
           (instructions (chain document (get-element-by-id "instructions"))))
       (setf controls (new (chain *three* (*my-pointer-lock-controls camera blocker instructions)))))
     ;; add controls to scene
     (chain scene (add (chain controls (get-object))))
     ;; pass canvas to renderer
     (let ((my-canvas (chain document (get-element-by-id "my-canvas"))))
       (setf renderer (new (chain *three* (*web-g-l-renderer (create canvas my-canvas))))))
     ;; set renderer resolution
     (chain renderer (set-size (@ window inner-width) (@ window inner-height)))
     ;; create cube obj
     (let ((geometry (new (chain *three* (*box-geometry 1 1 1))))
           (material (new (chain *three* (*mesh-basic-material (create color 0x00FF00))))))
       (setf cube (new (chain *three* (*mesh geometry material)))))
     ;; add cube to scene
     (chain scene (add cube)))

   ;; window resize listener
   (defun on-window-resize ()
     (let ((width (@ window inner-width))
           (height (@ window inner-height)))
       (setf (@ camera aspect) (/ width height))
       (chain camera (update-projection-matrix))
       (chain renderer (set-size width height))))

   ;; loop
   (defun animate ()
     ;; get frame delta
     (var delta (chain clock (get-delta)))
     ;; update view
     (chain controls (animate-camera delta))
     ;; update scene objects
     (incf (@ cube rotation x) 0.01)
     (incf (@ cube rotation y) 0.02)
     ;; render scene
     (chain renderer (render scene camera))
     ;; animate next frame
     (request-animation-frame animate))


   ;;; where the magic happens

   ;; initialize
   (init)
   ;; add listeners
   (chain window (add-event-listener "resize" on-window-resize false))
   ;; run
   (animate)))
