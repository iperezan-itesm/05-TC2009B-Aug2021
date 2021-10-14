% TEST
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{slides}[28/06/2019 Provides slides templates]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions \relax

\LoadClass{beamer}

\RequirePackage{xkeyval}

\def\docauthorname{Isaac P\'erez Andrade}
\def\docname{\jobname.tex}
\def\docdate{August - December 2020}

\define@key{slides.cls}{author}[Isaac P\'erez Andrade]{%
  \def\slideauthor{#1}%
}

\define@key{slides.cls}{date}[August - December 2020]{%
  \def\slidedate{#1}%
}

\define@key{slides.cls}{title}[Computer Architecture - TE2031]{%
  \def\slidetitle{#1}%
}

\setbeamertemplate{caption}[numbered]


\newif\ifprintpdf
\newcommand{\pauseprint}{\ifprintpdf\else\pause\fi}

\ExecuteOptionsX{author, date, title}
\ProcessOptionsX

% Presentation title
\title{\slidetitle}
% Author
\author{\slideauthor}
% Date
\date{\slidedate}
% Course title
\subject{Computer Architecture}
% University

\institute[ITESM GDA]{ITESM Guadalajara\\Department of Engineering \& Architecture\\ 
Department of Computer Science\\}
% http://deic.uab.es/~iblanes/beamer_gallery/index_by_theme.html
\usetheme{Madrid}
\usefonttheme{serif}
% Insert TEC logo
\titlegraphic{\includegraphics[width=3.5cm]{TEC.png}}

% Enumerate styles
\setbeamertemplate{enumerate items}[default]

% Add slide for each new section
\AtBeginSection[]{
  \begin{frame}
  \vfill
  \centering
  \begin{beamercolorbox}[sep=8pt,center,shadow=true,rounded=true]{title}
    \usebeamerfont{title}\insertsectionhead\par%
  \end{beamercolorbox}
  \vfill
  \end{frame}
}

% Load cfg files
\input{../../../../tex_pkg/cfg_packages}
\input{../../../../tex_pkg/cfg_acronyms}
\input{../../../../tex_pkg/cfg_code_style}
\input{../../../../tex_pkg/cfg_definitions}


% Location of your graphics files
\graphicspath{{../../../../figures/}}   












%\RequirePackage{fancyhdr}

%\AtBeginDocument{%
%\lhead[\docauthorname]{\docauthorname}%
%\chead[\docdate]{\docdate}%
%\rhead[]{\docname}%
%\pagestyle{fancy}%
%}
%\endinput