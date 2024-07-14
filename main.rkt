#lang racket
;;(require compatibility/defmacro) ;; compatibility-lib
(require while-until) ;; while-until
(require json)
(require base64)

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


(define (to-json x #:indent? [indent? #f]) (jsexpr->string x #:indent (if indent? 2 #f)))

(define (from-json json) (string->jsexpr json))

(define (files-read-json path)
  (define json (files-read-text path))
  (from-json json)
  )

(define (files-write-json path x)
  (define json (to-json x #:indent? #t))
  (files-write-text path json)
  )

(define (to-base64 x)
  (bytes->string/latin-1 (base64-encode x))
  )

(define (from-base64 x)
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
 to-base64
 from-base64
 )
