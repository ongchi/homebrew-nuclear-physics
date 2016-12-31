class F2c < Formula
  desc "Fortran to C Compiler from Netlib"
  homepage "https://github.com/ongchi/f2c"
  head "https://github.com/ongchi/f2c.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install

    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

end
