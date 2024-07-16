#lang racket
;;(require compatibility/defmacro) ;; compatibility-lib
(require while-until) ;; while-until
(require json)
(require base64)
(require pprint-all)
(require misc)
(require meta-json)

(define (files-read-bytes path #:buffer-size [buffer-size 4096])
  (call-with-input-file path
    (lambda (input-port)
      (define buffer (make-bytes buffer-size))
      (define result #"")
      (define bytes-read #f)
      (until (eof-object? bytes-read)
        (unless (eof-object? bytes-read)
          (when bytes-read (set! result (bytes-append result (subbytes buffer 0 bytes-read))))
          )
        (set! bytes-read (read-bytes-avail! buffer input-port))
        )
      result
      )
    )
  )

(define (files-write-bytes path x)
  (call-with-output-file path
    (lambda (output-port)
      (write-bytes x output-port)
      )
    #:exists 'truncate/replace
    )
  (void)
  )

(define (files-read-text path #:buffer-size [buffer-size 4096])
  (define bytes (files-read-bytes path  #:buffer-size buffer-size))
  (bytes->string/utf-8 bytes)
  )

(define (files-write-text path s)
  (define bytes (string->bytes/utf-8 s))
  (files-write-bytes path bytes)
  )

(define (files-read-sexp path)
  (call-with-input-file path
    (lambda (input-port)
      (define result (read input-port))
      result
      )
    )
  )

(define (files-write-sexp path x)
  (call-with-output-file path
    (lambda (output-port)
      (write x output-port)
      )
    #:exists 'truncate/replace
    )
  (void)
  )

#;(define (to-meta-pair name data)
  (hasheq '! name '? data)
  )

#;(define (from-meta-pair ht)
  (with-handlers ([exn:fail?
                   ht])
    (let ([key (hash-ref ht '!)])
      (cond
        ((equal? key "bytes") (from-base64 (hash-ref ht '?)))
        ((equal? key "racket")
         (define sp (open-input-string (hash-ref ht '?)))
         (read sp))
        (#t ht)
        )
      )
    )
  )

#;(define (to-meta-object x)
  (define mo
    (cond
      ;;((null? x) x)
      ;;((number? x) x)
      ;;((string? x) x)
      ((bytes? x) (to-meta-pair "bytes" (to-base64 x)))
      ((cons? x) (cons (to-meta-object (car x)) (to-meta-object (cdr x))))
      ((hash? x)
       (hash-map/copy
        x
        (lambda (k v)
          (values k (to-meta-object v))
          )))
      ((vector? x) (vector->list (vector-map to-meta-object x)))
      ;;((vector? x) (vector-map to-meta-object x))
      (#t x)
      )
    )
  (if (jsexpr? mo) mo (to-meta-pair "racket" (print->string mo)))
  )

#;(define (from-meta-object mo)
  (define x
    (cond
      ;;((null? x) x)
      ;;((number? x) x)
      ;;((string? x) x)
      ;;((bytes? x) (to-meta-pair "bytes" (to-base64 x)))
      ((cons? mo) (cons (from-meta-object (car mo)) (from-meta-object (cdr mo))))
      ((hash? mo)
       (if (hash-has-key? mo '!)
           (from-meta-pair mo)
           (hash-map/copy
            mo
            (lambda (k v)
              (values k (from-meta-object v))
              ))))
      ((vector? mo) (vector-map from-meta-object mo))
      (#t mo)
      )
    )
  x
  )

#;(define (to-json x #:indent? [indent? #f])
  (define mo (to-meta-object x))
  (jsexpr->string mo #:indent (if indent? 2 #f))
  )

#;(define (from-json json) (string->jsexpr json))

(define (files-read-json path)
  (define json (files-read-text path))
  (from-json json)
  )

(define (files-write-json path x)
  (define json (to-json x #:indent? #t))
  (files-write-text path json)
  )

#;(define (to-base64 x)
  (bytes->string/latin-1 (base64-encode x))
  )

#;(define (from-base64 x)
  (base64-decode x)
  )

(provide
 files-read-bytes
 files-write-bytes
 files-read-text
 files-write-text
 files-read-sexp
 files-write-sexp
 to-json
 from-json
 files-read-json
 files-write-json
 )
