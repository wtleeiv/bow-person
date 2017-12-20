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


   ;;; function definitions

   (defun cube ()
     (let ((geometry (new (chain *three* (*box-geometry 1 1 1))))
           (material (new (chain *three* (*mesh-basic-material (create color 0x00FF00))))))
       (new (chain *three* (*mesh geometry material)))))

   (defun checkerboard (&optional (segments 8) (square-dim 10))
     (let* ((geometry (new (chain *three* (*plane-geometry square-dim square-dim segments segments))))
            (material-even (new (chain *three* (*mesh-basic-material (create color 0xCCCCFC)))))
            (material-odd (new (chain *three* (*mesh-basic-material (create color 0x444464)))))
            (materials (list material-even material-odd)))
       ;; rotate floor to proper orientation
       (chain geometry (rotate-x (/ (@ *math *pi*) -2)))
       ;; color squares
       (dotimes (x segments)
         (dotimes (y segments)
           (let* ((i (+ (* segments x) y))
                  (j (* 2 i))
                  (index (% (+ x y) 2)))
             (setf (getprop geometry 'faces j 'material-index) index
                   (getprop geometry 'faces (+ j 1) 'material-index) index))))
       ;; return floor obj
       (new (chain *three* (*mesh geometry (new (chain *three* (*mesh-face-material materials))))))))

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

     ;; scene-specific objects
     (var floor (checkerboard))
     (setf (@ floor position y) -1)
     (chain scene (add floor )))

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
