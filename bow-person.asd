(asdf:defsystem #:bow-person
  :description "3D bow fighting game"
  :license "Don't be a Jerk"
  :author "Tyler Lee"
  :mailto "wtleeiv@gmail.com"
  :homepage "http://wtleeiv.com"
  :depends-on (#:clack
               #:ningle
               #:cl-who
               #:parenscript)
  :serial t
  :components ((:module "src"
                :serial t
                :components ((:file "bow-person")))))
