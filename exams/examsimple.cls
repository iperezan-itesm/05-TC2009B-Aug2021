\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{exam}[17/08/2019 Provides a template for exams]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{document}}
\ProcessOptions \relax

\LoadClass[a4paper,11pt]{report}
                        
\RequirePackage{xkeyval}

\def\docauthorname{Isaac P\'erez Andrade}
\def\docname{\jobname.tex}
\def\docdate{August - December 2019}

\define@key{exam.cls}{author}[Isaac P\'erez Andrade]{%
  \def\examauthor{#1}%
}

\define@key{exam.cls}{date}[Generic Date]{%
  \def\examdate{#1}%
}

%\define@key{exam.cls}{title}[Generic Title]{%
%  \def\examttitle{#1}%
%}

\define@key{exam.cls}{number}[Generic Number]{%
  \def\examnumber{#1}%
}

\ExecuteOptionsX{author, date}
\ProcessOptionsX



% Class specific packages
\usepackage{fancyhdr}
\usepackage{vmargin}
\usepackage{lastpage}
\usepackage{hyperref}
%\usepackage{xcolor}
\usepackage[T1]{fontenc}
\usepackage{acronym}
\usepackage{hyperref}
\usepackage{enumitem}
%\hypersetup{
%    colorlinks,
%    linkcolor={red!50!black},
%    citecolor={blue!50!black},
%    urlcolor={blue!80!black}
%}

%\RequirePackage{fancyhdr}
%\AtBeginDocument{%
%\lhead[\title]{\title}%
%\chead[\docdate]{\docdate}%
%\rhead[]{\docname}%
%\pagestyle{fancy}%
%}

\pagestyle{fancy}

\newcommand{\fref}[1]{Figure~\ref{#1}}
\newcommand{\tref}[1]{Table~\ref{#1}}
\newcommand{\aref}[1]{Appendix~\ref{#1}}
\newcommand{\sref}[1]{Section~\ref{#1}}

\newcommand{\marking}[1]{
\ifnum#1>1
  {\textbf{[#1 points]}}
\else
  {\textbf{[#1 point]}}
\fi
}

\newcommand{\answer}[1]{
\ifanswers~\newline\textcolor{blue}{#1}\fi
}

\newcommand{\multiplechoiseanswer}[1]{
\ifanswers\textcolor{blue}{#1}
\else #1
\fi
}

\renewcommand\thesection{\arabic{section}}
\renewcommand\thesubsection{\thesection.\arabic{subsection}}
\renewcommand{\labelenumii}{\theenumii}
\renewcommand{\theenumii}{\theenumi.\arabic{enumii}.}

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



\ifnum \examnumber = 0
  \newcommand{\examtitle}{Digital electronics diagnostic exam}
  %{\rhead{Digital electronics diagnostic exam}}
\else 
  \ifnum \examnumber = 1
    \newcommand{\examtitle}{First partial exam}
    %{\rhead{First partial exam}}
  \else 
    \ifnum \examnumber = 2
      \newcommand{\examtitle}{Second partial exam}
      %{\rhead{Second partial exam}}
    \else 
      \ifnum \examnumber = 3
        \newcommand{\examtitle}{Final exam}
        %{\rhead{Final exam}}
      \fi
    \fi
  \fi 
\fi

\rhead{\examtitle}
\lhead{Name}

%\lhead[\rm\thepage]{\fancyplain{}{\sl{\rightmark}}}
%\rhead[\fancyplain{}{\sl{\leftmark}}]{\rm\thepage}
%\chead{}\lfoot{}\rfoot{}\cfoot{}

% Presentation title
\title{\title}
% Author
\author{\examauthor}
% Date
\date{\examdate}
% Course title
% University


% Load cfg files
\input{cfg_packages}
\input{cfg_acronyms}
\input{cfg_definitions}
\input{cfg_code_style}

% Location of your graphics files
\graphicspath{{../figures/}}  


\endinput



