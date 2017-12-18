(defpackage #:bow-person.client.script
  (:use #:cl #:parenscript)
  (:export #:homepage))
(in-package #:bow-person.client.script)

(defun script-js (params)
  (declare (ignore params))
  (ps-to-stream *standard-output*
    (defvar scene (new (chain *three* (*scene))))
    (defvar camera (new (chain *three* (*perspective-camera 75 ; FOV (degrees)
                                                            ;; aspect ratio
                                                            (/ (@ window inner-width)
                                                               (@ window inner-height))
                                                            ;; near
                                                            0.1
                                                            ;; far
                                                            1000))))
    (defvar renderer (new (chain *three* (*web-g-l-renderer))))
    (chain renderer (set-size (@ window inner-width) (@ window inner-height)))
    (chain document body (append-child (@ renderer dom-element)))

    (defvar geometry (new (chain *three* (*box-geometry 1 1 1))))
    (defvar material (new (chain *three* (*mesh-basic-material (create color 0x00FF00)))))
    (defvar cube (new (chain *three* (*mesh geometry material))))
    (chain scene (add cube))

    (setf (@ camera position z) 5)

    (defun animate ()
      (request-animation-frame animate)

      (incf (@ cube rotation x) 0.01)
      (incf (@ cube rotation y) 0.02)

      (chain renderer (render scene camera)))

    (animate)))


