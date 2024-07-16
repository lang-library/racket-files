#lang racket
(require "./main.rkt")
(require "./data1.rkt")
(require pprint-all)
(require misc)
(require access)

(dump xyz.dll)

(files-read-bytes "./data1.rkt")
(files-read-text "./data1.rkt")

(files-read-bytes "./data1.rkt" #:buffer-size 5)
(files-read-text "./data1.rkt" #:buffer-size 5)

(files-write-sexp "./data2.txt" '(a b #[1 2 3]))
(dump (files-read-sexp "./data2.txt"))

(dump (files-read-json "./data3.json"))
(files-write-json "./data4.json" (files-read-json "./data3.json"))
(dump (files-read-text "./data4.json"))

(define hash (files-read-json "./data3.json"))
(dump (hash-ref hash '|hello world|))

(dump (win-userprofile))

(! (win-userprofile)
   (string->path !)
   )

(! (win-userprofile)
   (build-path ! "abc")
   )
   
