#lang racket

(require 2htdp/batch-io)
;; step 1 -> write helper functions to create the bit masks
;; step 2 -> write function that reads in input from the file
;; step 3 -> learn how to use hash maps in racket
;; step 4 -> run the input text file

(define instructions
  (read-lines "input.txt"))

(define test-instructions
  (list
    "mask = 000000000000000000000000000000X1001X"
    "mem[42] = 100"
    "mask = 00000000000000000000000000000000X0XX"
    "mem[26] = 1"
    ))
    
(define (parse instr)
  (string-split instr " = "))

(define (prepare-masks mask)
  (cons
    (string->number (string-replace mask "X" "1") 2)
    (string->number (string-replace mask "X" "0") 2)))

(define (parse-addr addr)
  (string->number (first (regexp-match #px"\\d+" addr))))

(define (compute-addrs addr mask)
  (define addrs (list))
  (define (helper s i n)
    (if (= i n)
        (set! addrs (cons (string->number s 2) addrs))
        (cond
          [(char=? #\X (string-ref mask i))
             (helper (string-append s "0") (+ i 1) n)
             (helper (string-append s "1") (+ i 1) n)]
          [(char=? #\1 (string-ref mask i))
             (helper (string-append s "1") (+ i 1) n)]
          [else
             (helper (string-append s (~a (string-ref addr i)))
                     (+ i 1)
                     n)])))
  (helper "" 0 (string-length addr))
  addrs) 

(define (make-addr addr)
  (let ([base (number->string addr 2)])
    (string-append
      (make-string (- 36 (string-length base)) #\0)
      base)))

(define (part1-run instructions)
  (let ([mem (make-hash)]
        [masks '()])
    (for ([instr instructions])
        (set! instr (parse instr))
        (cond
          [(string=? "mask" (car instr)) 
            (set! masks (prepare-masks (second instr)))]
          [else 
            (let ([loc (car instr)]
                  [val (bitwise-and 
                         (car masks) 
                         (bitwise-ior 
                           (cdr masks) 
                           (string->number (second instr))))])
            (hash-set! mem loc val) )]))
    (foldl + 0 (hash-values mem))))

(define (part2-run instructions)
  (let ([mem (make-hash)]
        [mask '()])
    (for ([instr instructions])
      (set! instr (parse instr))
      (cond
        [(string=? "mask" (car instr))
          (set! mask (second instr))]
        [else
          (let* ([address (parse-addr (car instr))]
                 [locs (compute-addrs (make-addr address) mask)])
            (for ([addr locs])
              (hash-set! mem addr (string->number (second instr)))))]))
    (foldl + 0 (hash-values mem))))


;; (part1-run instructions) ;; part 1

(part2-run instructions)
