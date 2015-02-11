class F2c < Formula
  homepage "https://github.com/juanjosegarciaripoll/f2c"
  url "https://github.com/juanjosegarciaripoll/f2c/archive/master.zip"
  sha1 "c21fcb9022e120d5f832bcef8f9e3badd20371e1"
  version "20120201"

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
