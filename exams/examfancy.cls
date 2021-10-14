\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{examfancy}[17/08/2019 Provides a template for fancy exams]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{document}}
\ProcessOptions \relax

\LoadClass[letterpaper,12pt,addpoints,answers]{exam}
                        
\RequirePackage{xkeyval}

\def\docauthorname{Isaac P\'erez Andrade}
\def\docname{\jobname.tex}
\def\docdate{August - December 2019}

\define@key{examfancy.cls}{author}[Isaac P\'erez Andrade]{%
  \def\examauthor{#1}%
}

\define@key{examfancy.cls}{date}[Generic Date]{%
  \def\examdate{#1}%
}

%\define@key{exam.cls}{title}[Generic Title]{%
%  \def\examttitle{#1}%
%}

\define@key{examfancy.cls}{number}[Generic Number]{%
  \def\examnumber{#1}%
}

\ExecuteOptionsX{author, date}
\ProcessOptionsX



% Class specific packages
%\usepackage{fancyhdr}
\usepackage{vmargin}
\usepackage{lastpage}
%\usepackage{hyperref}
\usepackage{xcolor}
\usepackage[T1]{fontenc}
\usepackage{acronym}
\usepackage[colorlinks=true,linkcolor=black,anchorcolor=black,citecolor=black,filecolor=black,menucolor=black,runcolor=black,urlcolor=black]{hyperref}
\usepackage{enumitem}
\usepackage[utf8]{inputenc}

\usepackage{booktabs}

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

%\pagestyle{fancy}
\newcommand{\acrotable}[1]{\textbf{\acs{#1}} & \acl{#1}}
%\newcommand{\fref}[1]{Figure~\ref{#1}}
%\newcommand{\tref}[1]{Table~\ref{#1}}
%\newcommand{\aref}[1]{Appendix~\ref{#1}}
%\newcommand{\sref}[1]{Section~\ref{#1}}


%\newcommand{\answer}[1]{
%\ifanswers~\newline\textcolor{blue}{#1}\fi
%}
\renewcommand{\solutiontitle}{\noindent\textbf{Solution:}\par\noindent}
\renewcommand{\thechoice}{\alph{choice}}
\CorrectChoiceEmphasis{\color{blue}}

% Command to print solutions
\newcommand{\answer}[2]{
\vspace{#1pt}
\begin{solution}
\textcolor{blue}{#2}
\end{solution}
}

\newcommand{\multiplechoiseanswer}[1]{
\ifanswers\textcolor{blue}{#1}
\else #1
\fi
}

% Create a box with a header with basic instructions.
\newcommand{\makeboxheader}{
\begin{center}
\fbox{\fbox{\parbox{0.95\textwidth}{
\begin{center}
Answer the questions in the spaces provided or continue in extra pages if you need, clearly stating the question number.
\\
Unless stated otherwise, no partial marks will be awarded in multiple choice questions.\\
Do not forget to write down your name in every extra page you use.\\
Calculators are not allowed.
\end{center}
}}}
\end{center}
}

% Create space for name and student ID
\newcommand{\makenameline}{ 
\vspace{3mm}~\\
\makebox[0.95\textwidth]{Name \& Student ID\enspace\hrulefill} 
%\vspace{5mm}~\\
%\makebox[0.9\textwidth]{Student ID:\enspace\hrulefill}
}

% Create a grade table
\newcommand{\makegradetablebonus}{
\begin{center}
\combinedgradetable[v][questions]
\end{center}
}

\newcommand{\makegradetable}{
\begin{center}
\setlength{\doublerulesep}{0.1pt}
\vqword{Question}
\vpword{Points}
%\vsword{text}
\vtword{\textbf{TOTAL}}
\multicolumngradetable{3}[questions]
\end{center}
}

\renewcommand\thesection{\arabic{section}}
\renewcommand\thesubsection{\thesection.\arabic{subsection}}
\renewcommand{\labelenumii}{\theenumii}
\renewcommand{\theenumii}{\theenumi.\arabic{enumii}.}

%\documentclass[12pt]{article}

%\fancyhf{}
%\setmarginsrb           { 1.1in}  % left margin
%                        { 0.6in}  % top margin
%                        { 1.0in}  % right margin
%                        { 0.8in}  % bottom margin
%                        {  20pt}  % head height
%                        {0.25in}  % head sep
%                        {   9pt}  % foot height
%                        { 0.3in}  % foot sep
\footer{}{Page \thepage\ of \numpages}{}

%\rfoot{Page \thepage \hspace{1pt} of \pageref{LastPage}}



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

%\extrawidth{-0.1in}
\extrawidth{0.5in}
%\header{Computer Architecture}{\examtitle}{\examdate}
\header{Computer Architecture}{\examtitle}{13th Feb 2020}
%\rhead{\examtitle}
%\lhead{Computer Architecture}

%\lhead[\rm\thepage]{\fan\usepackage{cleveref}cyplain{}{\sl{\rightmark}}}
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
\input{../tex_pkg/cfg_packages}
\input{../tex_pkg/cfg_acronyms}
\input{../tex_pkg/cfg_definitions}
\input{../tex_pkg/cfg_code_style}

% Location of your graphics files
\graphicspath{{../figures/}}  


\endinput



