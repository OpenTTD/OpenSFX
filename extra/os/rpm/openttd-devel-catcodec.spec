
Name:           openttd-devel-catcodec
Version:        r17982
Release:        1%{?dist}
Summary:        CATCodec to en-/decode sound replacement files

Group:          Amusements/Games
License:        GPLv2
URL:            http://www.openttd.org/download-catcodec
Source0:        http://binaries.openttd.org/extra/catcodec/%{version}/catcodec-%{version}-source.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot

BuildRequires:  gcc-c++

Provides:	catcodec

%description
CATCodec does en-/decode sound replacement files. The last tool to
definitly independency of OpenTTD

%prep
%setup -qn catcodec-%{version}

%build
make %{?_smp_mflags} VERSION="%{version}"
strip catcodec

%install
install -D -m 755 catcodec %{buildroot}%{_bindir}/catcodec
install -D -m 644 catcodec.1 %{buildroot}%{_mandir}/man1/catcodec.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc COPYING
%{_mandir}/man1/catcodec.1*
%{_bindir}/catcodec

%changelog
* Thu Dec 10 2009 Marcel Gmür <ammler@openttdcoop.org> - r17982
- upstream update to r17982
- man page
- make REVISON changed to VERSION
- rename package
* Sat Sep 19 2009 Marcel Gmür <ammler@openttdcoop.org> - r17144
- initial build

