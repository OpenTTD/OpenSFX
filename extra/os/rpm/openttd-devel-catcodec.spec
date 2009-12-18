
Name:           openttd-devel-catcodec
Version:        1.0.0
Release:        1%{?dist}
Summary:        CATCodec to en-/decode sound replacement files

Group:          Development/Tools
License:        GPLv2
URL:            http://www.openttd.org/download-catcodec
Source0:        http://binaries.openttd.org/extra/catcodec/%{version}/catcodec-%{version}-source.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot

BuildRequires:  gcc-c++

Provides:       catcodec

%description
catcodec decodes and encodes sample catalogues for OpenTTD. These sample
catalogues are not much more than some meta-data (description and file name)
and raw PCM data.

catcodec is licensed under the GNU General Public License version 2.0. For
more information, see the file 'COPYING'.

%prep
%setup -qn catcodec-%{version}

%build
make %{?_smp_mflags}

%install
install -sD -m0755 catcodec %{buildroot}%{_bindir}/catcodec
install -D -m0644 catcodec.1 %{buildroot}%{_mandir}/man1/catcodec.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc COPYING README
%{_mandir}/man1/catcodec.1*
%{_bindir}/catcodec

%changelog
* Fri Dec 18 2009 Marcel Gmür <ammler@openttdcoop.org> - 1.0.0
- upstream release 1.0.0
* Thu Dec 10 2009 Marcel Gmür <ammler@openttdcoop.org> - r17982
- upstream update to r17982
- man page
- make REVISON changed to VERSION
- rename package
* Sat Sep 19 2009 Marcel Gmür <ammler@openttdcoop.org> - r17144
- initial build
