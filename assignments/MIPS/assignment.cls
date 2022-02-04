\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{assignment}[17/08/2019 Provides a template for assignments]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{document}}
\ProcessOptions \relax

\LoadClass[a4paper,11pt]{report}

\RequirePackage{xkeyval}

\def\docauthorname{Isaac P\'erez Andrade}
\def\docname{\jobname.tex}
\def\docdate{February - June 2020}

\define@key{assignment.cls}{author}[Isaac P\'erez Andrade]{%
  \def\assignmentauthor{#1}%
}

\define@key{assignment.cls}{date}[Generic Date]{%
  \def\assignmentdate{#1}%
}

\define@key{assignment.cls}{title}[Generic Title]{%
  \def\assignmenttitle{#1}%
}

\define@key{assignment.cls}{number}[Generic Number]{%
  \def\assignmentnumber{#1}%
}

\ExecuteOptionsX{author, date, title}
\ProcessOptionsX

\input{../../tex_pkg/cfg_packages}
\input{../../tex_pkg/cfg_acronyms}
\input{../../tex_pkg/cfg_definitions}
\input{../../tex_pkg/cfg_code_style}

% Class specific packages
% Class specific packages
\hypersetup{
    colorlinks,
    linkcolor={blue},
    citecolor={blue},
    urlcolor={blue}
}
\usepackage{vmargin}



\RequirePackage{fancyhdr}
\AtBeginDocument{%
%\lhead[\title]{\title}%
%\chead[\docdate]{\docdate}%
%\rhead[]{\docname}%
\pagestyle{fancy}%
}

\pagestyle{fancy}

\newcommand{\marking}[1]{
\ifnum#1>1
  {\textbf{[#1 points]}}
\else
  {\textbf{[#1 point]}}
\fi
}


%\usepackage{titlesec}% http://ctan.org/pkg/titlesec
%\titleformat{\section}%
%  [hang]% <shape>
%  {\normalfont\bfseries\Large}% <format>
%  {}% <label>
%  {0pt}% <sep>
%  {}% <before code>

\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}
\renewcommand{\thefigure}{\arabic{figure}}
\renewcommand{\thetable}{\arabic{table}}
%\renewcommand\thesection{\arabic{section}}
%\renewcommand\thesubsection{\thesection.\arabic{subsection}}
%\renewcommand{\labelenumii}{\theenumii}
%\renewcommand{\theenumii}{\theenumi.\arabic{enumii}.}

%\documentclass[12pt]{article}

\fancyhf{}
\setmarginsrb           { 1.1in}  % left margin
                        { 0.6in}  % top margin
                        { 1.0in}  % right margin
                        { 0.8in}  % bottom margin
                        {  20pt}  % head height
                        {0.25in}  % head sep
                        {   9pt}  % foot height
                        { 0.3in}  % foot sep

\rfoot{Page \thepage \hspace{1pt} of \pageref{LastPage}}
%\chead{Final Project}
\lhead{Computer Architecture}
%\lhead[\rm\thepage]{\fancyplain{}{\sl{\rightmark}}}
%\rhead[\fancyplain{}{\sl{\leftmark}}]{\rm\thepage}
%\chead{}\lfoot{}\rfoot{}\cfoot{}

% Presentation title
\title{\title}
% Author
\author{\assignmentauthor}
% Date
\date{\assignmentdate}
% Course title
% University


% Load cfg files


% Location of your graphics files
\graphicspath{{../../figures/}}


\endinput
