require "formula"

# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  homepage "https://www.gnu.org/software/wget/"
  url "http://ftpmirror.gnu.org/wget/wget-1.16.tar.xz"
  mirror "https://ftp.gnu.org/gnu/wget/wget-1.16.tar.xz"
  sha1 "08d991acc80726abe57043a278f9da469c454503"

  bottle do
    revision 2
    sha1 "173036d8c100beb821b6af936a8dfc562a8dad4c" => :yosemite
    sha1 "825f0187d75ab9d42888901a43aae6104e834af9" => :mavericks
    sha1 "71e28c9e7325a85668a9bb965ce67cbcc64a550b" => :mountain_lion
  end

  head do
    url "git://git.savannah.gnu.org/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-iri" => "with-iri"
  deprecated_option "enable-debug" => "with-debug"

  option "with-iri", "Enable iri support"
  option "with-debug", "Build with debug support"

  depends_on "openssl"
  depends_on "libidn" if build.include? "enable-iri"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-debug" unless build.include? "enable-debug"
    args << "--disable-iri" unless build.include? "enable-iri"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/wget", "-O", "-", "www.google.com"
  end
end
