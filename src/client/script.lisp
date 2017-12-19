(defpackage #:bow-person.client.script
  (:use #:cl #:parenscript)
  (:export #:homepage))
(in-package #:bow-person.client.script)

(defun script-js (params)
  (declare (ignore params))
  (ps-to-stream *standard-output*
    (defvar scene (new (chain *three* (*scene))))
    (defvar clock (new (chain *three* *clock)))
    (defvar camera (new (chain *three* (*perspective-camera 75 ; FOV (degrees)
                                                            ;; aspect ratio
                                                            (/ (@ window inner-width)
                                                               (@ window inner-height))
                                                            ;; near
                                                            0.1
                                                            ;; far
                                                            1000))))
    (let ((blocker (chain document (get-element-by-id "blocker")))
          (instructions (chain document (get-element-by-id "instructions"))))
      (defvar controls (new (chain *three* (*my-pointer-lock-controls camera blocker instructions)))))
    (chain scene (add (chain controls (get-object))))
    ;; pass canvas to renderer
    (let ((my-canvas (chain document (get-element-by-id "my-canvas"))))
      (defvar renderer (new (chain *three* (*web-g-l-renderer (create canvas my-canvas))))))
    (chain renderer (set-size (@ window inner-width) (@ window inner-height)))

    (defvar geometry (new (chain *three* (*box-geometry 1 1 1))))
    (defvar material (new (chain *three* (*mesh-basic-material (create color 0x00FF00)))))
    (defvar cube (new (chain *three* (*mesh geometry material))))
    (chain scene (add cube))

    (setf (@ camera position z) 5)

    (defun on-window-resize ()
      (let ((width (@ window inner-width))
            (height (@ window inner-height)))
        (setf (@ camera aspect) (/ width height))
        (chain camera (update-projection-matrix))
        (chain renderer (set-size width height))))

    ;; add window resize event listener
    (chain window (add-event-listener "resize" on-window-resize false))

    (defun animate ()
      (var delta (chain clock (get-delta)))

      (chain controls (animate-camera delta))

      (incf (@ cube rotation x) 0.01)
      (incf (@ cube rotation y) 0.02)

      (chain renderer (render scene camera))

      (request-animation-frame animate)
      )

    (animate)))
