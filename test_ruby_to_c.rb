#!/usr/local/bin/ruby -w

require 'test/unit'
require 'ruby_to_c'
require 'something'

class TestRubyToC < Test::Unit::TestCase

  @@empty = "void\nempty() {\n}"
  @@simple = "void\nsimple(void arg1) {\nprint(arg1);\nputs(4 + 2);\n}"
  @@stupid = "VALUE\nstupid() {\nreturn Qnil;\n}"
  @@global = "void\nglobal() {\nfputs(\"blah\", stderr);\n}"
  @@lasgn_call = "void\nlasgn_call() {\nlong c = 2 + 3;\n}"
  @@conditional1 = "long\nconditional1(long arg1) {\nif (arg1 == 0) {\nreturn 1;\n};\n}"
  @@conditional2 = "long\nconditional2(long arg1) {\nif (arg1 == 0) {\n;\n} else {\nreturn 2;\n};\n}"
  @@conditional3 = "long\nconditional3(long arg1) {\nif (arg1 == 0) {\nreturn 3;\n} else {\nreturn 4;\n};\n}"
  @@conditional4 = "long\nconditional4(long arg1) {\nif (arg1 == 0) {\nreturn 2;\n} else {\nif (arg1 < 0) {\nreturn 3;\n} else {\nreturn 4;\n};\n};\n}"
  @@iteration1 = "void\niteration1() {\nlong_array array;\narray.contents = { 1, 2, 3 };\narray.length = 3;\nunsigned long index_x;\nfor (index_x = 0; index_x < array.length; ++index_x) {\nlong x = array.contents[index_x];\nputs(x);\n};\n}"
  @@iteration2 = "void\niteration2() {\nlong_array array;\narray.contents = { 1, 2, 3 };\narray.length = 3;\nunsigned long index_x;\nfor (index_x = 0; index_x < array.length; ++index_x) {\nlong x = array.contents[index_x];\nputs(x);\n};\n}"
  @@iteration3 = "void\niteration3() {\nlong_array array1;\narray1.contents = { 1, 2, 3 };\narray1.length = 3;\nlong_array array2;\narray2.contents = { 4, 5, 6, 7 };\narray2.length = 4;\nunsigned long index_x;\nfor (index_x = 0; index_x < array1.length; ++index_x) {\nlong x = array1.contents[index_x];\nunsigned long index_y;\nfor (index_y = 0; index_y < array2.length; ++index_y) {\nlong y = array2.contents[index_y];\nputs(x);\nputs(y);\n};\n};\n}"
  @@multi_args = "char *\nmulti_args(void arg1, void arg2) {\nputs(arg1 * arg2);\nreturn \"foo\";\n}"
  @@bools = "long\nbools(void arg1) {\nif (NIL_P(arg1)) {\nreturn 0;\n} else {\nreturn 1;\n};\n}"

  @@__all = []

  Something.instance_methods(false).sort.each do |meth|
    if class_variables.include?("@@#{meth}") then
      @@__all << eval("@@#{meth}")
      eval "def test_#{meth}; assert_equal @@#{meth}, RubyToC.translate(Something, :#{meth}); end"
    else
      eval "def test_#{meth}; flunk \"You haven't added @@#{meth} yet\"; end"
    end
  end

  def ztest_class
    assert_equal(@@__all.join("\n\n"),
		 RubyToC.translate_all_of(Something))
  end

end
