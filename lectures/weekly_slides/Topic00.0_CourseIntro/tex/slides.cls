% TEST
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{slides}[28/06/2019 Provides slides templates]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions \relax

\LoadClass{beamer}

\RequirePackage{xkeyval}

\def\docauthorname{Isaac P\'erez Andrade}
\def\docname{\jobname.tex}
\def\docdate{February - June 2021}

\define@key{slides.cls}{author}[Isaac P\'erez Andrade]{%
  \def\slideauthor{#1}%
}

\define@key{slides.cls}{date}[February - June 2021]{%
  \def\slidedate{#1}%
}

\define@key{slides.cls}{title}[TE2003B \\ SoC design: Computer organization \& architecture \\ Course introduction]{%
  \def\slidetitle{#1}%
}

\setbeamertemplate{caption}[numbered]


\newif\ifprintpdf
\newcommand{\pauseprint}{\ifprintpdf\else\pause\fi}

\ExecuteOptionsX{author, date, title}
\ProcessOptionsX

% Presentation title
\title[SoC Design: Computer Architecture]{\slidetitle}
% Author
\author[IPA]{\slideauthor}
% Date
\date{\slidedate}
% Course title
\subject{SoC Design: Computer Architecture}
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


\setbeamertemplate{footline}
{
  \leavevmode%
  \hbox{%
  \begin{beamercolorbox}[wd=.85\paperwidth,ht=2.25ex,dp=1ex,center]{title in head/foot}%
    \usebeamerfont{title in head/foot}\insertshorttitle
  \end{beamercolorbox}%
  \begin{beamercolorbox}[wd=.15\paperwidth,ht=2.25ex,dp=1ex,center]{author in head/foot}%
    \usebeamerfont{author in head/foot}\hspace*{3em}
    \insertframenumber{} / \inserttotalframenumber\hspace*{1ex}
  \end{beamercolorbox}}%
  \vskip0pt%
}
%\makeatletter
\setbeamertemplate{navigation symbols}{}

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