#lang racket
(require "./main.rkt")
(require "./data1.rkt")
(require pprint-all)

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

(to-base64 #"apple")
(to-json (to-base64 #"apple"))

(to-meta-object #"apple")
(dump (to-json #"apple"))
(dump (to-json '(11 22 #"apple")))
(dump (to-json '#(11 22 #"apple")))
(dump (to-json '#hasheq((! . "bytes") (? . "YXBwbGU"))))
(dump (to-json '#hasheqv((! . "bytes") (? . "YXBwbGU"))))
(dump (to-json '#hash((! . "bytes") (? . "YXBwbGU"))))
(dump (to-json '#hash(((a b c) . "bytes") (? . "YXBwbGU"))))

(dump (from-meta-object (to-meta-object #"apple")))
(dump (from-meta-object (to-meta-object '(11 22 #"apple"))))
(dump (from-meta-object (to-meta-object '#(11 22 #"apple"))))
(dump (from-meta-object (to-meta-object '#hasheq((! . "bytes") (? . "YXBwbGU")))))
(dump (from-meta-object (to-meta-object '#hasheqv((! . "bytes") (? . "YXBwbGU")))))
(dump (from-meta-object (to-meta-object '#hash((! . "bytes") (? . "YXBwbGU")))))
(dump (from-meta-object (to-meta-object '#hash(((a b c) . "bytes") (? . "YXBwbGU")))))
