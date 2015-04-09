context('')

test_that('', {
  expect_equal(E(1:7, FALSE), 4)
  expect_equal(E(1:8, FALSE), 4.5)
  expect_equal(E(1:8, FALSE, dokl = 0), 4)
  
  expect_equal(E(1:7, dokl = 1), '                 4.0')
  expect_equal(E(1:8), '      4.50')
  
  expect_equal(E(1:3), '         -')
  expect_equal(E(1:3, TRUE, 2), '                  -')
  expect_equal(E(1:3, FALSE), '-')
  expect_equal(E(1:3, FALSE, 2), '-')
  
  expect_equal(E('a'), '         -')
})